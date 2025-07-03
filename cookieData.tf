data "external" "getCookies"{
    program = ["python", "${path.module}/getCookieData.py"]
}

# output "cookies"{
#     value = data.external.getCookies.result.result
# }