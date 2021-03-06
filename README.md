# GNU Make and M4 Static Website Generator

One of the first hacks that I was really proud of was a static website generator that I built in late 1999 with some venerable old Unix tools, [GNU Make](http://www.gnu.org/software/make/) and [GNU m4](http://www.gnu.org/software/m4/). The article [Using M4 to write HTML](http://web.archive.org/web/19980529230944/http://www.linuxgazette.com/issue22/using_m4.html) by Bob Hepple was my original inspiration to build it that way. At that time I think I was able to surpass the utility of the examples given therein, and since then I've attempted to whittle this old hack down into a bunch of modular parts that one might use to build their own, or simply to learn about GNU Make.

**You're currently viewing the 'master' branch of this repository.** I've tried to include here many interesting features and ideas for how this technique might be used, including the use of [Pandoc](http://johnmacfarlane.net/pandoc/) for markdown-format source files. I've tried to include a generous amount of internal documentation and comments as well, but it may yet be a lot to absorb at once. To more easily understand what's going on here, be sure to take a look at the 'simple' branch of the repository: http://github.com/datagrok/m4-bakery/tree/simple

## Site Baking

"Website baking" is the pattern of building from templates a mostly- or completely-static website that requires no special software to serve. Baking a website provides huge advantages when it can be employed, because they:

- have fewer vectors for break-ins, 
- easily scale to handle massive amounts of traffic, and 
- may be hosted on commodity hardware or the cheapest of web hosting services.

Of course, with no processing occurring on the server end, it's not possible to host user-interactive features like comments sections, authentication, or e-commerce systems. These days however, many people use third-party tools like [Disqus](http://disqus.com) to implement these features anyway.

In short, if you're not using any of the dynamic features of your web hosting service, you might as well make the whole site static. If you are using those features for some pieces of your site, you're better off making the static parts simple static files.

## GNU Make and GNU M4

That is of course only an argument for building static websites. Doing it in this _particular_ way may be... ill-advised.

Though m4 may be venerable and may come pre-installed on several modern Unix platforms, it brings along a notoriously cumbersome syntax for defining and calling macros, escaping, quoting, and other things. Sendmail's configuration system serves as a cautionary tale, as it was built upon m4 and is legendary for being obtuse. Employing m4 may be an exercise in masochism.

The difficulty in employing m4 may contribute to my pride in having built a useful tool with it a whole decade+ ago. I hope that this repository will yet serve as an instructive example of how to 'bake' a website using ubiquitous Unix tools, even if every single user ends up swapping out m4 for modern template software, e.g. [Jinja](http://jinja.pocoo.org/).

## Features

- m4: The HTML template is wrapped around .html.m4 files automatically; no boilerplate or "include" statements are necessary in the source files.
- m4: The HTML template is a single file, not a separate header and footer.
- Makefile: Files named .m4 don't get the template, but still get interpreted by m4.
- Makefile: Any files not named '.m4' don't get interpreted by m4; they are copied verbatim.
- m4: Macros defined in source .html.m4 files will be expanded in the template. This lets you put complex logic in the template and trigger it from the source file. For example, you could set the page title, toggle a template style, define sidebars, etc.
- m4: Macros defined in the macros file will be expanded in the source files and the template. You can define macros here that you want to be available everywhere.

## Execution

Beginning with source files like this:

	src/
	|-- index.html.m4
	`-- style.css

Along with the Makefile, macros file, and HTML template, running 'make' will
output:

	install -m 644 -D src/style.css dst/style.css
	m4 -P macros.m4 src/index.html.m4 template.html.m4 > src/index.html
	install -m 644 -D src/index.html dst/index.html
	rm src/index.html

And produce the following structure:

	dst/
	|-- index.html
	`-- style.css

# Directory layout

This repository contains the following:

    .
    |-- build/                      # The default locaiton for rendered HTML (not in version control)
    |-- demo-src/                   # Source files for an example website
    |-- etc/                        # Includeable or "plugin" files
    |-- macros.m4                   # M4 macros made available to every M4 file
    |-- Makefile                    # GNU Makefile, defines how to transform source files into HTML
    |-- README.md
    `-- template.html.m4            # An HTML template that will wrap all content

# Similar projects

It has been said that every programmer, at some point, writes a blog/website publishing engine. Here are some other such projects that are similar in some way.

## Friends

- [ironfroggy](https://github.com/ironfroggy)'s [jules](https://github.com/ironfroggy/jules)
- [nathanielksmith](https://github.com/nathanielksmith)'s [Cadigan](https://github.com/nathanielksmith/cadigan)
- [redline6561](https://github.com/redline6561)'s [Coleslaw](https://github.com/redline6561/coleslaw)
- [veselosky](https://github.com/veselosky)'s [Otto Webber](https://github.com/veselosky/otto-webber)

## Forks

- Brandon Invergo's [m4-bloggery](https://gitorious.org/bi-websites/m4-bloggery) is based on m4-bakery and takes some slightly different approaches.

## Others

- jaspervdj's semi-automated [Static Site Generators Listing](http://staticsitegenerators.net)
- davatron5000's [crowdsourced recommendations gist](https://gist.github.com/davatron5000/2254924)


# License

The `demo-src` part of this repository includes unmodified copies of:

- [Modernizr](http://modernizr.com/), License: MIT
- [jQuery](http://jquery.org), License: MIT

These resources, of course, retain their original license.

The parts of this repository that I wrote are released under the terms of the [GNU Affero General Public License](http://www.gnu.org/licenses/agpl-3.0.html) verison 3 or later.

If these terms don't meet your needs, just contact me.
