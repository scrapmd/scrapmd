window.ExtensionPreprocessingJS = ((url, html) => ({
  run: arguments => {
    arguments.completionFunction({ html, url });
  },
  finalize: () => {}
}))(document.location.href, document.body.innerHTML);
