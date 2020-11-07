function init()
    m.top.functionName = "getContent"
    m.top.config = {}
end function

function getContent()
    parseInitialParams()
    valid = validateInitialParams()

    if valid
        getJson()
    end if
end function

function parseInitialParams()
    url = m.top.url
    if Type(url) <> "roString"
        url = Invalid
    else
        url = url.trim()
    end if

    config = m.top.config
    if Type(config) <> "roAssociativeArray"
        config = {}
    else
        secured = config.secured
        if Type(secured) <> "roBoolean"
            secured = false
        end if
        config.secured = secured

        certificate = config.certificate
        if Type(certificate) = "roString"
            certificate = certificate.trim()
        end if
        config.certificate = certificate

        httpHeaders = config.httpHeaders
        if Type(httpHeaders) <> "roAssociativeArray"
            httpHeaders = Invalid
        end if
        config.httpHeaders = httpHeaders
    end if

    m.top.config = config
    m.top.url = url
end function

function validateInitialParams()
    valid = true
    if m.top.url = Invalid
        ? "No valid Url passed to 'getJson' component"
        valid = false
    end if
    return valid
end function

function getJson()
    url = m.top.url
    config = m.top.config

    port = CreateObject("roMessagePort")
    urlTransfer = createObject("roUrlTransfer")
    urlTransfer.setUrl(m.top.url)
    urlTransfer.SetMessagePort(port)

    httpHeaders = config.httpHeaders
    if httpHeaders <> Invalid
        urlTransfer.SetHeaders(httpHeaders)
    end if

    secured = config <> Invalid AND config.secured
    secured = secured OR -1 <> url.Instr("https://")

    if secured
        certificate = "common:/certs/ca-bundle.crt"
        if Type(config.certificate) = "roString" and config.certificate <> ""
            certificate = config.certificate
        end if
        urlTransfer.SetCertificatesFile(certificate)
        urlTransfer.InitClientCertificates()
    end if

    sent = urlTransfer.AsyncGetToString()

    if sent
        while true
            msg = wait(100, port) ' wait for a message
            if type(msg) = "roUrlEvent" then
                response = {}
                responseCode = msg.GetResponseCode()
                response.responseCode = responseCode
                if responseCode < 0
                    response.failReason = msg.GetFailureReason()
                    response.jsonString = Invalid
                    response.data = Invalid
                else
                    response.failReason = Invalid
                    response.jsonString = msg.GetString()
                    response.data = ParseJson(response.jsonString)
                end if
                m.top.response = response
            end if
        end while
    end if
end function
