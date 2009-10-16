Scoped-Tags
===========

To say that this plugin is better than other tagging plugins/gems would be an outright lie.

Each have there power and weakness, scoped-tags aims to fill a small gap where tags can be specified for a category of tag,
and also allow for cross use of comma separated strings and the association helpers which rails gives you for free.
The comma separated list is kept in sync with the association (in most cases) so that nasty before\_save and after\_save 
filters are not needed. 


Tagging plugin comparisons
--------------------------

differences between acts-as-taggable-on and is-taggable



How can I use it?
-----------------

    class Person
      scoped_tags :genres
    end

    me = Person.new(:name => 'Josh')

    me.interests << Tag.new(:name => 'scuba', :context => 'interests') 
    # it would be nice to leave the context out, but sadly not just yet
    # and me.interests.build(:name => 'scuba') does not work at the moment either 
    # (has_many through issue)

    me.genre_tags => ['scuba']

    me.genre_tags << 'cycling'
    # comma seperated strings are excepted, as well as arrays of strings

    me.genres => [#<Tag id: nil, name: "scuba", context: 'interests'>,#<Tag id: nil, name: "cycling", context: 'interests'>]
    


Things to watch out for
-----------------------

- updating model (transaction and params)



Future enhancements
-------------------

- turn TagList into more of a proxy instead of half Array and half beast
- add strict scoping on setup (scoped_tags :interests, :strict => true), thus any tag added which is not already in the tags table for that context will be rejected
- get the instance.context.build method to work correctly
