A little helper to easily download JSON from web for ROKU channel developers

### How to include getJson in Your channel
1. Download getJson.pkg file from build folder.
2. Paste .pkg file into Your ROKU channel inside components catalog.
3. Include Component library inside XML file, as follows:
```xml
<ComponentLibrary id="getJson" uri="pkg:/components/getJson.pkg" />
```
4. Make sure that component Library is loaded properly
``` brightScript
    function init()
        m.componentLibrary = m.top.findNode("getJson")
        m.componentLibrary.observeField("loadStatus", "onComponentLibraryLoadStatusChange")
    end function

    function onComponentLibraryLoadStatusChange()
        if m.componentLibrary.loadStatus = "ready"
            ? "You can start using Component library right here!"
        else
            ? "component library was not loaded properly"
        end if
    end function
```
### How to use
Example of usage can be found below:
```brightScript

function getJson()
    m.getJson = CreateObject("roSGNode", "abd:getJson")
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

```
### API
| name | Type | Accessibility | Description |
|--|--|--|--|
| `url` | `string` | read / write | Allows setting url to desired resource |
| `config` | `assocArray` | read / write | Allows setting configuration for http request. Following attributes can be set : `secured` determinate whenever `https` is used, `certificate` allows setting certificate file (pass through path to file), `httpHeaders` used to pass through http headers |
| `response` | `assocArray` | read | Response object contains the following: `data`, `failReason`, `jsonString`, `responseCode` |

### Project Structure
- `.vscode` config for Visual Studio Code
- `build` folder should contain latest getJson component
- `src` source code of getJson component library
- `testChannel` simple channel which utilize getJson component