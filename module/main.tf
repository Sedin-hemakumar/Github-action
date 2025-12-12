
resource "aws_route53_zone" "my_reverse_zone" {
  name = var.hosted_zone_name
  comment = var.comment
  dynamic "vpc" {
    for_each = var.vpc_ids
    content {
      vpc_id = vpc.value
    }
  }
    lifecycle {
    ignore_changes = [tags]  # Ignores tag changes
  }
  tags = {
    ZoneType    = length(var.vpc_ids) > 0 ? "private" : "public"
  }
}


resource "aws_route53_record" "soa_record" {
  zone_id = aws_route53_zone.my_reverse_zone.id
  name    = var.soa_record_name
  type    = var.soa_recordtype
  ttl     = var.soa_record_ttl
  records = var.soa_record_records
}
resource "aws_route53_record" "ns_record" {
  zone_id = aws_route53_zone.my_reverse_zone.id
  name    = var.ns_record_name
  type    = var.ns_record_type
  ttl     = var.ns_record_ttl
  records = var.ns_record_records
}

resource "aws_route53_record" "ptr_record" {
  zone_id = aws_route53_zone.my_reverse_zone.id
  name    = var.ptr_record_name
  type    = var.ptr_record_type
  ttl     = var.ptr_record_ttl
  records = var.ptr_record_records
}
