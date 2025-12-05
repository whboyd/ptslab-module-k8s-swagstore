# =================
# k8s swagstore
# =================

resource "network" "main" {
  subnet = "10.0.0.0/24"
}

resource "kubernetes_cluster" "k8s" {
  network {
    id = resource.network.main.meta.id
  }
  resources {
    cpu    = 3000  # 2 CPUs
    memory = 6144  # 4GB
  }
  config {
    docker {
      insecure_registries = ["public.ecr.aws/v6x4t1k2", "public.ecr.aws"]
      no_proxy            = ["public.ecr.aws"]
    }
  }
  port {
    local = "8080"
  }
  port {
    local = "80"
  }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/adservice:ddintrov2"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/cartservice:ddintrov2"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/checkoutservice:298ecf5"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/currencyservice:298ecf5"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/emailservice:298ecf5"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/frontend:noUtmPass"
  // }
  // // copy_image {
  // //   name = "ubuntu:latest"
  // // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/loadgenerator:298ecf5"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/paymentdbservice:298ecf5"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/paymentservice:ddintrov2"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/productcatalogservice:298ecf5"
  // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/recommendationservice:298ecf5"
  // }
  // // copy_image {
  // //   name = "redis:alpine"
  // // }
  // copy_image {
  //   name = "public.ecr.aws/v6x4t1k2/shippingservice:298ecf5"
  // }
}
# file path used by instruqt to store module files:
# /root/.instruqt/modules/github.com_whboyd_ptslab-module-k8s-swagstore_modules_swagstore-k8s/

resource "kubernetes_config" "swagstore" {
  cluster = resource.kubernetes_cluster.k8s
  paths = ["/root/.instruqt/modules/github.com_whboyd_ptslab-module-k8s-swagstore_modules_swagstore-k8s/k8s/nginx/"]
  wait_until_ready = false
  // health_check {
  //   timeout = "3000s"
  //   pods = ["app=frontend"]
  // }
}

resource "container" "k8s_proxy" {
  depends_on = ["resource.kubernetes_config.swagstore"]

  image {
    name = "bitnami/kubectl:latest"
  }
  
  command = ["port-forward", "--address=0.0.0.0", "svc/frontend", "8080:80"]

  network {
    id = resource.network.main.meta.id
  }

  volume {
    source      = resource.kubernetes_cluster.k8s.kube_config.path
    destination = "/.kube/config"
    type        = "bind"
  }

  port {
    local = "8080"
  }
  port {
    local = 80
  }
}

resource "service" "frontend" {
  target = resource.container.k8s_proxy
  port   = "8080"
  path   = "/"
  scheme = "http"
}
