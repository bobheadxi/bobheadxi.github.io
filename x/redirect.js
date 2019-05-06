const packages = [

];

function $id(id) {
  return document.getElementById(id);
}

function loadHTML(url) {
  req = new XMLHttpRequest();
  req.open('GET', url);
  req.send();
  return req;
}

function formatGoRepoHTML(repo, content) {
  content = content.replace('{{ .Repo }}', `https://github.com/bobheadxi/${repo}`);
  content = content.replace('{{ .CanonicalURL }}', `bobheadxi.dev/x/${repo}`);
  return content;
}

function loadGoRepo(repo) {
  loadHTML('./gopkg.html').onload = () => {
    $id('view').innerHTML = formatGoRepoHTML(repo, req.responseText);
  };
}

// no hash
router = new Navigo(null, false);

// route all to gopkg for now
router.on('/:repo', (params) => {
  console.log(params.repo);
  loadGoRepo(repo);
});

// set the default route
router.on(() => { $id('view').innerHTML = '<h2>Nothing to see here!</h2>'; });

router.resolve();
