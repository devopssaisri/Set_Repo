# Use Ubuntu LTS as base
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache (httpd) and curl (for healthcheck). Clean apt cache to keep image small.
RUN apt-get update \
 && apt-get install -y --no-install-recommends apache2 curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy website content (add your files under ./html)
COPY ./html /var/www/html/

# Expose HTTP port
EXPOSE 80

# Basic healthcheck to ensure Apache responds
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Run Apache in foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
