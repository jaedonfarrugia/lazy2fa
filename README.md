# Lazy2FA

Are you too lazy to to open your phone to enter a 2fa code on your computer? If so, then this app is for you.

Lazy2FA is a Ruby-based TUI tool that enables two-factor authentication (2FA) without the need for a mobile phone apps like Authy/Google Authenticator.

## Features

- Generate TOTP (Time-Based One-Time Password) codes
- Command-line interface

## Prerequisites

- Ruby 2.5+ (https://www.ruby-lang.org/en/documentation/installation/)
- Bundler (https://bundler.io/guides/getting_started.html)

## Setup

Note: this has currently only been tested on MacOS

1. Clone the repository:

```bash
  cd ~ && git clone https://github.com/jaedonfarrugia/lazy2fa.git
```

2. Install dependencies:

```bash
  cd ~/lazy2fa && bundle install
```

3. Configure environment variables in your .env file (bashrc, zshrc, etc.):<br>
   **VERY IMPORTANT, MAKE SURE TO CHANGE THE DEFAULT VALUES OF THE PASSPHRASE AND SALT**

```bash
  echo 'export LAZY_2FA_PASSPHRASE="FOO"' >> ~/.zshrc
  echo 'export LAZY_2FA_SALT="BAR"' >> ~/.zshrc
  source ~/.zshrc
```

3. Configure an alias to access the application from anywhere:

```bash
  echo 'function 2fa {
    if [[ -n "$1" ]]; then
      ruby ~/lazy2fa/bin/app.rb --g "$1"
    else
      ruby ~/lazy2fa/bin/app.rb
    fi
  }' >> ~/.zshrc
  source ~/.zshrc
```

4. Run the app from anywhere on your machine by calling `2fa`

5. Add a service (eg, Github)<br>
   <img width="226" alt="Screenshot 2024-06-04 at 3 31 45 am" src="https://github.com/jaedonfarrugia/lazy2fa/assets/44693739/7ed5942c-2028-494a-9717-7c13bdd9dc7b">
6. Enter the TOTP key. You will need to click something like "Having trouble scanning this QR code?" to view the Base32 TOTP key
7. You can then generate a Github 2fa token at any time by running eg; `2fa github`<br>
   <img width="416" alt="Screenshot 2024-06-04 at 2 57 10 pm" src="https://github.com/jaedonfarrugia/lazy2fa/assets/44693739/4bc6b8ac-3862-4db9-8f32-a5284c0c2e70">
8. Repeat step 5 & 6 for as many apps as you would like
9. Enjoy!

## Contributing

- Fork the repository.
- Create a new branch (git checkout -b feature-branch).
- Commit your changes (git commit -am 'Add new feature').
- Push to the branch (git push origin feature-branch).
- Create a new Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please open an issue on the GitHub repository.
