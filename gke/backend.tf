terraform {
  backend "gcs" {
    bucket = "tf-state-francesko"  
    prefix = "root"                
  }
}