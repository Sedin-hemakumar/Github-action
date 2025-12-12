output "hosted_zone_name" {
  value = aws_route53_zone.my_reverse_zone.name
}
output "hosted_zone_id" {
  value = aws_route53_zone.my_reverse_zone.zone_id
}
output "ZoneType" {
  description = "PUBLIC or PRIVATE hosted zone"
  value       = length(var.vpc_ids) > 0 ? "PRIVATE" : "PUBLIC"
}
