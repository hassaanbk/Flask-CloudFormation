# Generate a random password and set the "password" parameter value
resource "random_password" "this_password" {
  length           = 16
  special          = true
  override_special = "!#%^*()-_+=[]{}|;:,.<>?~"
}

locals {
  parameters = merge(var.parameters,
    { password = random_password.this_password.result }
  )
}

# Create the parameters using a loop over the map keys
resource "aws_ssm_parameter" "this_parameter" {
  for_each  = local.parameters
  type      = "String"
  name      = each.key
  value     = each.value
  overwrite = true
}
