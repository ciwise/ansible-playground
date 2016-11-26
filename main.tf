resource "digitalocean_droplet" "ciwise-3" {
    image = "debian-8-x64"
    name = "ciwise-3"
    region = "nyc2"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    provisioner "file" {
       connection {
          type = "ssh"
	  user = "root"
	  private_key = "~/.ssh/id_rsa"
       }
      source="script.sh"
      destination = "/tmp/script.sh"
    }
    
    provisioner "remote-exec" {
      connection {
         type = "ssh"
	  user = "root"
          private_key = "~/.ssh/id_rsa"
       }
       inline = [
         "chmod 777 /tmp/script.sh", 
	 "/tmp/script.sh"
       ]
    }

}

resource "digitalocean_domain" "default" {
  name = "ansible.ciwise.com"
  ip_address = "${digitalocean_droplet.ciwise-3.ipv4_address}"
}

output "ip_ciwise" {
  value = ["${digitalocean_droplet.ciwise-3.ipv4_address}"]
}
