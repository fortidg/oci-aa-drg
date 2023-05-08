// create ubuntu instance
resource "oci_core_instance" "ubu-spoke1" {
  depends_on          = [oci_core_internet_gateway.igw]
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "${var.PREFIX}-ubu-spoke1"
  shape               = var.ubu_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.spoke1-sub2.id
    display_name     = "ubu-spoke1-vnic"
    assign_public_ip = false
    hostname_label   = "ubu-spoke1-vnic"
  }

  launch_options {
    network_type = "PARAVIRTUALIZED"
  }

  source_details {
    source_type             = "image"
    source_id               = var.ubu-image
    boot_volume_size_in_gbs = "50"
  }

  // Required for bootstrapp
  // Commnet out the following if you use the feature.
  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
    user_data = "${base64encode(file("./boot.sh"))}"
  }
}