resource "shoreline_notebook" "dns_cache_poisoning_incident" {
  name       = "dns_cache_poisoning_incident"
  data       = file("${path.module}/data/dns_cache_poisoning_incident.json")
  depends_on = [shoreline_action.invoke_stop_clear_restart_dns,shoreline_action.invoke_install_dnssec]
}

resource "shoreline_file" "stop_clear_restart_dns" {
  name             = "stop_clear_restart_dns"
  input_file       = "${path.module}/data/stop_clear_restart_dns.sh"
  md5              = filemd5("${path.module}/data/stop_clear_restart_dns.sh")
  description      = "Clear the DNS cache: The first step in remediation is to clear the DNS cache to remove any poisoned entries. This can be done by restarting the DNS server or flushing the cache manually."
  destination_path = "/tmp/stop_clear_restart_dns.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "install_dnssec" {
  name             = "install_dnssec"
  input_file       = "${path.module}/data/install_dnssec.sh"
  md5              = filemd5("${path.module}/data/install_dnssec.sh")
  description      = "Implement DNSSEC: DNS Security Extensions (DNSSEC) is a protocol designed to secure the DNS system against attacks like cache poisoning. Implementing DNSSEC can help prevent future attacks."
  destination_path = "/tmp/install_dnssec.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_stop_clear_restart_dns" {
  name        = "invoke_stop_clear_restart_dns"
  description = "Clear the DNS cache: The first step in remediation is to clear the DNS cache to remove any poisoned entries. This can be done by restarting the DNS server or flushing the cache manually."
  command     = "`chmod +x /tmp/stop_clear_restart_dns.sh && /tmp/stop_clear_restart_dns.sh`"
  params      = ["DNS_SERVICE_NAME"]
  file_deps   = ["stop_clear_restart_dns"]
  enabled     = true
  depends_on  = [shoreline_file.stop_clear_restart_dns]
}

resource "shoreline_action" "invoke_install_dnssec" {
  name        = "invoke_install_dnssec"
  description = "Implement DNSSEC: DNS Security Extensions (DNSSEC) is a protocol designed to secure the DNS system against attacks like cache poisoning. Implementing DNSSEC can help prevent future attacks."
  command     = "`chmod +x /tmp/install_dnssec.sh && /tmp/install_dnssec.sh`"
  params      = []
  file_deps   = ["install_dnssec"]
  enabled     = true
  depends_on  = [shoreline_file.install_dnssec]
}

