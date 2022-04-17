console.log("hello world")

function postMessage(name, message) {
    window.webkit.messageHandlers[name].postMessage(message);
}

// 监听图片点击事件

document.querySelectorAll("img")
.forEach(v => v.addEventListener("click", (event) => postMessage("doc-img-click", {"src": encodeURI(decodeURI(v.getAttribute("src")))})))
