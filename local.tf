
locals {
  ingress_rules1 = [
    {
      port        = 22
      description = "Ingress for SSH"
    },
    {
      port        = 80
      description = "Ingress for HTTP"
    },
    {
      port        = 443
      description = "Ingress for HTTPS"
    }
  ]
  ingress_rules2 = [
    {
      port        = 8080
      description = "Ingress for Apache/TomCat, Jenkins"
    },
    {
      port        = 3306
      description = "Ingress for MySql"
    },
  ]
}