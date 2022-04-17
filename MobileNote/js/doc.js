console.log("hello world")

function postMessage(name, message) {
    window.webkit.messageHandlers[name].postMessage(message);
}

// 监听图片点击事件
function onImgClick(img) {
    postMessage("doc-img-click", {
        "src":  encodeURI(decodeURI(img.getAttribute("src"))),
        "name": img.getAttribute("alt")
    })
}
document.querySelectorAll("img")
.forEach(v => v.addEventListener("click", (event) => onImgClick(v)))
