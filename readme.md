Scoped-Tags
===========

To say that this plugin is better than other tagging plugins/gems would be an outright lie.
Each have there power and weakness, scoped-tags aims to fill a small gap where tags can be specified for a category of tag,
and also allow for cross use of comma separated strings and the relationship helps which rails gives for free.


More
----

differences between acts-as-taggable-on and is-taggable



Quick notes for development
---------------------------

scoped_tags :genres # default is :strict (do not add new tags, strict scoping)

me.genres << Tag.new(:name => 'tony', :scope => 'genre')

me.genre_tags => ['tony']