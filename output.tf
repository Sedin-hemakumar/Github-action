output "hosted_zone_name" {
  value = module.Route53.hosted_zone_name
}
output "hosted_zone_id" {
  value = module.Route53.hosted_zone_id
}
output "ZoneType" {
  description = "PUBLIC or PRIVATE hosted zone"
  value       = module.Route53.ZoneType
}
