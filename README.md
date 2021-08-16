# Xantora

A PDF-converter for [Antora](https://antora.org/) (AsciiDoc) documents.

This Ruby CLI-Tool uses [asciidoctor-pdf](https://asciidoctor.org/docs/asciidoctor-pdf/) and makes it easy to export PDF's from Antora projects.

## Installation

Install the gem:

```sh
gem install xantora
```

## Usage

Convert a single AsciiDoc document:

```bash
xantora convert modules/user-guide/pages/index.adoc
```

Convert a all documents within an Antora component:

```bash
xantora convert modules/
```

Convert all documents and store PDF's in the attachment folders (using option `--to-attachments` or `-A`):

```bash
xantora convert modules/ --to-attachments 
```

See `xantora help` for more usage instructions.

## Features

- Preconfigured [asciidoctor-pdf](https://asciidoctor.org/docs/asciidoctor-pdf/) setup wich makes it simple to convert single Antora documents or whole modules into PDF's
- Integrated PDF-theme suppport which makes your documents look good out of the box
- Uses the santisized AsciiDoc document title as PDF filename
- Sets the image-path according your Antora folder structure
- Autodetects `antora.yml` configs in order to extract metadata such as `page-component-title`, which can be used in themes (i.e. header and footer)
- Optionaly Xantora will safe PDF's in attachments folders coresponding to source documents

## Known Limitations

- Images referenced outside the documents own Antora module can't be loaded
- Same limitations as with asciidoctor-pdf do apply, see [asciidoctor-pdf known-limitations](https://github.com/asciidoctor/asciidoctor-pdf#known-limitations)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/niwo/xantora. This project is intended to be a safe, welcoming space for collaboration.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
