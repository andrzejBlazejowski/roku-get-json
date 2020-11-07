function init()
    m.top.setFocus(true)
    m.myLabel = m.top.findNode("label")

    m.myLabel.font.size=92

    m.myLabel.color="0x6F9DC7FF"
    getJson()
end function

function getJson()
    m.getJson = CreateObject("roSGNode", "getJson")
    m.getJson.url = "https://jsonplaceholder.typicode.com/posts/24"
    m.getJson.config = {
        "secured": true
    }
    m.getJson.observeField("response", "handleResponse")
    m.getJson.control = "run"
end function

function handleResponse()
    if m.getJson = invalid OR m.getJson.response = invalid 
        return Invalid
    end if
    response = m.getJson.response

    ? "response : "; response
    ? "response.jsonString : "; response.jsonString
    ? "response.data : "; response.data
    ? "response.responseCode : "; response.responseCode
    ? "response.failReason : "; response.failReason

end function