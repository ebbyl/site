# ---------------------------------------------------------------------
# Tags
# ---------------------------------------------------------------------

# Define tags used to identify the infrastructure resources for 
# this application. 

locals {
  tags = {
    owner     = "product"
    project   = "ebb"
    component = "product.ebb.site"
  }
}
