window.ExtensionPreprocessingJS = ((url, title, html) => ({
  run: arguments => {
    arguments.completionFunction({ html, title, url });
  },
  finalize: () => {}
}))(document.location.href, document.title, document.body.innerHTML);
