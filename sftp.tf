# Create ssh key pairs for the job module
# This will be used to connect to the SFTP server

module "sftp-server" {
  source  = "./sftp/server"
  #region  = var.region
  ##vpc_id  = module.vpc.vpc_id
  ##subnet_ids = module.vpc.private_subnets

  tags = {bartu = "test"}

}

module "sftp-users" {
  source         = "./sftp/user"
  
  sftp_server_id = one(module.sftp-server.*.server_id)
  s3_bucket_name = one(module.sftp-server.*.bucket_name)
  s3_bucket_arn  = one(module.sftp-server.*.bucket_arn)
  user_map = {
    # pmg's job module
    # job = {
    #   authorized_keys = tls_private_key.ssh[count.index].public_key_openssh
    # }

    # # EW People BEGIN
    # "jiri.kuzel" = {
    #   authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBTt8M4FFc5X1LJAXS4YnmsEhkQuEXbNsQb6rwwa9XQ9A16kCJ3HLKRYaHuBBoxX0OfARkPutYE5y1jYWvhQKoVaxfHfMa/X/mU1RWeOdFsH2ISsB0MFKQQmjBpskMETtgZ5RYgWDIA5qToqYfisKisVVLqtclUihSYb/uiXzUQomDvMP4/dUet48Ocqy3YGnkQsXl8gDxhvjGXqWFCNU5ae/kxGN8WndpY4o8QZUuWVeiJLM5t208tq7q542n8wfL5p+aZzE8sJe9ENMPSPKIBuiAJvOm8QyHp1X8e5b+TORB8TLRiTdoS0I6HA8HaVqvr81URCSzsBy9sYHUJIcdJyW1789sNecNzGHTCAmesveIPCMkj8Jj2HyWBXO/p642skLOv2+uh2Jb8dvmZQscdcv0DwqnkWcRcrGVGO/lpCOARpKurUDesfSrWMilZcc0rcGEBCKxKLBGppMze2Vd/YjXJ4ZsjTmEhzri7YcQDrk6j70sxKN7xtRBxUW8MXfMmIrd0aMoZF+M0Jq2AzhbNP3Ugpi5rxT9CKVUmDFs23GiaLQF80p8Rsnuq5sPvWbzHq78iFfc6s06RORlYksyUjwhh4K0X1Do6g6NATwuyKPUmYPBC6mabHdpxvIFM3Uc2nit7C2WFZU99TtjbIi/tbXSRkYNYRNvKUOARhtvuw== kuzelka@kukuair.local"
    # }
    # "petr.kulhanek" = {
    #   authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJZGPilZhEtyWrtgxLMfY0hI+sCK/DsYrJs8JhiMA54dREqkeN/b2HHwXyZfOYrsZUqMs8+DZil4l5bBplhkk17Sk4V+nFq3Kzi8Kg3iwMy9dfnrdRkOCrARl4Mw2kE6aYU0cGi+gg0dCdU3glKRoc0NWQGVEggEGyym08OEevRPHU6YEL3yiQ8c7iVMHSDfvuVA1QEd9J5WFOXm1/Y6ipJ72/SanO6uEokpTPQ6caa+GlCbXzMcNnRgaWwCF0opahXk+s6832R5F/zCVJitQUBeQDqSTvzP8E5LRwu3S1Y1FKetwJYg+f2QZ7OXJlg4ToBsZQBM8i1eQrd3hScooN rsa-key-20220516"
    # }
    # "michal.svondr" = {
    #   authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJxTWmi/NvNDegSa7VjhlUgvnBUUYdqTOJuR0dFEKY2aoRSUiAIg9pqWuip+2Iyedwvef+yjwSg3GbdbcgsK4CO0RG1C6RiZc4ZHf5q9H5fDhPntOrlCUayjguxFkDXrpgZ0VSRH66IJAIiXv1nwxTLvPtg47ipNxX9gAX/QJYJPQFkmPTtynGHwoGGmLimFaQQ+U++nl12uMpWVXDj1w+fZF4y7iw6Wvgvac9aW4+L3aO1SDyZmYrlPQ4a1zD10y0Nuz4wC+xHGzZeGkllbwBFLVcd6Mro2cdUT+L4JktJAiWQ2NLjo6pZs6Z7aEivy9QZ7L/JhixdMhAP25Zbphv rsa-key-20220513"
    # }
    # "cyril.adamec" = {
    #   authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCCzkybfS0WnT7m66xJq1yNKW9QYTp8R5S1S5ziVDMC2dZgeImjbGKgLkAuqxo5agKCBEtBSPo57g16UU/YGWgmOHU3xRCJa37STKXISi8zjpy2W53E5JsOPKj8ZuBwolWlefmyg5dnib0oFFGB6Hnmp/fWSEzQmIYFkAw3EMODF8az2Y3Vdv7/KlcEMp+kuASWncnyck3F2v7b7/kVTlWByXZSZ4eT0XrQkyXevo5asZR5XwjSzE8TTmcFfYJjDNNoVqY93Q/BViCm82oUz+KvI9Of4cl3KHwIVxJJREOdirTXK8GYVXRF4DX0PnhutWt2VYJVo3ylrkSuhXnaII7h"
    # }
    # # EW People END

    # # Trustsoft users
    # silviu = {
    #   authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIJltleSKl6plZxIOTp6XbghK48CXa3UGD7S+JPgtQWrC06Z2qCU+DSv+6neJY1cOH+rNOzW1250+Vmxlyw1bZxnXd8FFyWT8rhpiZGYBpbNmKnkH5+PCf4X+/95G2dZ77I+NASgqMH2OxE6pPIrI3Ia9Yo+Ych8fk7o5dSOtWRUmcCY2xVv2shbEWMTGWX05b4mFznlx/14KeCV8Bxwyy9P3pW9ovu645LiDlqB2FELffLMdrD3ngoETdx9KUOz3IHIbt1Pdr4YyMWO6wwyXAHn9OFi987R/ntGO66m8YKCo9D1IKx2gNVfwd+treYT5LHUa5P2Bdf02p6Y1ZisCR mykey"
    # }
    # petr = {
    #   authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBI2Al+h997lxzXenePAc4EK9pJhouZPPa96iu01SnrEquef+5Jj7L/VMbyID0YneOC/iGtpS4Iy3EfWFK1nK5FAo/O8E2sTmJ4/q/R3ykaEA4GqCVefAdQrYihwedTe0fs99uERdUQZd63IhULfm4d4/LNf/MIynGd+xPNXA+XYR7w0hAAvu24f+f3CVps2cLgg3BZbVaz0qhdVaQcRDC2iwgzcc82O2RsaKfbVqCZMOQqisba4kMXjrKqb5HVg1LGdPVsfqdHdcTVQIW6/1r1PjPW5fqk8nGelG6XB17E97rZg7tQ6SuWeqM2SDFQXW6LjMZ4o+c61VtU3xMwSeCWnz/GQnHGh8B/LtAFiGPDz532nwdan/Qz4FdAOwP3ruwRJAy9cQJjYtnm3E1/n+Gjlj0bE4vpgW3KwsN6Dq8GkgepgLpmlVOTTHxBlJNphHA3rpKR1mYKmV07JK1f2tDm0aAgg/SENVazDzEY4kr4DeB/hmZ+NJNQKiCh6r16co2MRwpt5cxHxyAtZ8cLQUflAONbLlH2etz/dQmmgbW9N/uR6G0CyehBT29kv17ZD58pjFglqLhkckBLrXO6w2ELqFD25ylppAb/Yq6SERnJOa+cJ4sVqgZ4q/xubHQlbYYfMLdX/ZVa0ojUTyUR/zYyLPT/UpCH/dohFfZMZy+3Q== petr.motejlek"
    # }

    # # AEVI user
    # aevi = {
    #   authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDS6Htj9Z4aBSgwd2FHADwWVykd7K8Du2Iaa31eXBrTVZ7LpZJtCNa5+v5VRNfrbPlUOEbs4HiS+9j428iJIsRnr3J9qpZSVcalRgSPtAwAPnlA+z6gdVYnyKzbcvNO7A+t0Eyu4ksp7LIJHcgCniTH3hYqIC8lzVoEHjOhcV77mjjaZe0A0NuYtoMRc3OnskC32qXT77h0NQwZDIOBhoXOPbg23OqYC/T4aBFFUzY4t6UUtcBnwaCV0vDezG2YStq8S4ZjT74bUvKshKJBMPx5DuW83TqkAO0zgLdC5ORkYjEGnmBFJE+WTqImAxFft4CK8JWFVe7TxQt2jIhgsOVi6ki3qC+7/mjjAXK2F2t/yWA1zXO8C4LwEm4+FYCtLxP0oQw56AbERrTKMYwDGSsvVuUWm9QlPC1e8YMw2y9G3djudzxxnqhSuYpd+gWflKjk3zRF+b6oKqJyvJ2FzrGbzcKQ/QbbWbJ9JAJ46gPYy0tMAXgJzV84NpFbZ2qsvGM= semenko@LAPTOP-FFK9DM7G"
    # }
    bartu = {
      authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0c0qwjl4km6RXuZlYzLz3GSSzy330mYzsFxEkAGKOjzuc1JMLAfKQAAr+rXv3VtqTKuB8GQo7nTTWamjkYh2XSQI912/f4oKksp1V52shvAExQ6fLS4D4c8rUnxMf5ZwMVOkkzZCtxgcS9uDfvLAvdsCJqXw+39FLic4E5RyEnP/OJBuZtRu3Uy2Uvm8W6FZRW8eb1VA7TFGkWWNfv7GIDGSOm6UYjOjdKuBFFpZw2MBZ5zdsxE84ecy3IVnfbumHIhTFSP+aU2VVtEfUo9qij4OlmZJs7y7p02zKZJb7JiKQ7Oah74abf6MyPTUu4KyIPMLLjkrlFUxWxV0BcmKB bartu"
    }
  }

  tags = {bartu = "test"}

}
