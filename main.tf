locals {
region = "us-east-1"
hosted_zone_name = "71.53.52.in-addr.arpa"
soa_record_name = "71.53.52.in-addr.arpa"
soa_recordtype = "SOA"
soa_record_ttl = 900
soa_record_records = ["ns-1354.awsdns-41.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]

# NS Records
ns_record_name = "71.53.52.in-addr.arpa"
ns_record_type = "NS"
ns_record_ttl = 172800
ns_record_records = ["ns-1354.awsdns-41.org.",
    "ns-1615.awsdns-09.co.uk.",
    "ns-281.awsdns-35.com.",
    "ns-535.awsdns-02.net."]

# PTR Records
ptr_record_name = "84.71.53.52.in-addr.arpa"
ptr_record_type = "PTR"
ptr_record_ttl = 300
ptr_record_records = ["mail.sedintechnologies.net"]

#comment 
comment = "testing"
}
provider "aws" {
  region = local.region
}
 module "Route53" {
   source = "./module"
   hosted_zone_name = local.hosted_zone_name
   vpc_ids = []
   soa_record_name = local.soa_record_name
   soa_recordtype = local.soa_recordtype
   soa_record_ttl = local.soa_record_ttl
   soa_record_records = local.soa_record_records
   ns_record_name = local.ns_record_name
   ns_record_type = local.ns_record_type
   ns_record_ttl = local.ns_record_ttl
   ns_record_records = local.ns_record_records
   ptr_record_name = local.ptr_record_name
   ptr_record_type = local.ptr_record_type
   ptr_record_ttl = local.ptr_record_ttl
   ptr_record_records = local.ptr_record_records
   comment = local.comment
 }
