locals {
    ssh_user = "ubuntu"
    key_name ="my-key-pair"
}

resource "aws_instance" "nginx"{
    ami="ami-0dba2cb6798deb6d8"
    instance_type="t2.micro"
    associate_public_ip_address = true
    security_groups = ["example-security-group"]
    key_name=local.key_name

    provisioner "remote-exec"{
        inline = ["echo 'Wait until SSH is ready'"]

        connection{
            type ="ssh"
            user =local.ssh_user
            private_key = file("my-key-pair")
            host = aws_instance.nginx.public_ip
        }
    }
    provisioner "local-exec"{
        command = "ansible-playbook -i ${aws_instance.nginx.public_ip}, --private-key 'my-key-pair' nginx.yml"

    }
}

output "nginx_ip"{
    value = aws_instance.nginx.public_ip
}