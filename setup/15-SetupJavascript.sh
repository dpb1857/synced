
# Look here
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions

# Install nodejs
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Emacs linters
### http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html
npm install -g eslint babel-eslint eslint-plugin-react

############################################################


# Run npm to install create-react-app;
# https://github.com/facebookincubator/create-react-app
npm i create-react-app -g

# Create the app
create-react-app react-app

# Start dev environment
npm start # Looks for package.json

# Build a release
npm run build
