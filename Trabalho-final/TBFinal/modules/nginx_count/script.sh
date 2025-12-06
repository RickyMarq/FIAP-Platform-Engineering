#!/bin/bash
set -e

# Atualiza pacotes
yum update -y

# Instala nginx (Amazon Linux 2)
amazon-linux-extras install -y nginx1 || yum install -y nginx

# Conteúdo simples da página
cat > /usr/share/nginx/html/index.html <<'HTML'
<html>
  <head><title>FIAP - Terraform Count</title></head>
  <body>
    <h1>Nginx provisionado via Terraform</h1>
  </body>
</html>
HTML

# Sobe o serviço
systemctl enable nginx
systemctl restart nginx
