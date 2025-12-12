variable "hosted_zone_name" {}
variable "vpc_ids" {
  description = "VPC IDs for private hosted zone (empty list = public)"
  type        = list(string)
  default     = []
}
# SOA Records
variable "soa_record_name" {}
variable "soa_recordtype" {}
variable "soa_record_ttl" {}
variable "soa_record_records" {
    type = list(string)
}

# NS Record
variable "ns_record_name" {}
variable "ns_record_type" {}
variable "ns_record_ttl" {}
variable "ns_record_records" {
    type = list(string)
}

# PTR Record
variable "ptr_record_name" {}
variable "ptr_record_type" {}
variable "ptr_record_ttl" {}
variable "ptr_record_records" {}
variable "comment" {}
