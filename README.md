# website
Store Hugo's content and other source file of Choco-solver website.

> Les pages `docs/` et `tutos/` ne sont plus ici : elles vivent dans `docs/content/` du dépôt
> [choco-solver](https://github.com/chocoteam/choco-solver), importé comme module Hugo (voir `config.toml`).
> Après une release : `hugo mod get github.com/chocoteam/choco-solver@vX.Y.Z`, mettre à jour `choco_version`, puis `./deploy.sh`.
> Pour prévisualiser un clone local : `HUGO_MODULE_REPLACEMENTS="github.com/chocoteam/choco-solver -> /chemin/vers/choco-solver" hugo server`.
=======

Pour bien commencer, il faut avoir installé [Hugo](https://gohugo.io/).

1. Installer la dernière version stable de Node.js
2. Installer PostCSS: `npm install -g postcss-cli` and `npm install -g autoprefixer`
3. Installer Go (requis par les modules Hugo : thème Docsy et contenu de choco-solver), puis `npm ci`
4. Lancer la commande: `hugo server -D`
5. Se rendre sur le lien suivant: [http://localhost:1313/](http://localhost:1313/)
6. Constater que ça marche

Et voilà (ou presque). 
