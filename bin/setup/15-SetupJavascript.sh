

# Install npm;
sudo apt-get install npm
sudo ln -s /usr/bin/nodjs /usr/bin/node

# Run npm to install create-react-app;
# https://github.com/facebookincubator/create-react-app
npm i create-react-app -g

# Create the app
create-react-app react-app

# Start dev environment
npm start # Looks for package.json

# Build a release
npm run build

### Setup emacs;
### http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html

npm install -g eslint babel-eslint eslint-plugin-react
