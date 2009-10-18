Scoped-Tags
===========

When it comes to tagging dsls there are three main players, acts-as-taggable-on, acts-as-taggable-on-steriods and is-taggable.
Each seem to have one thing is common and thats using an after save callback to sync the tags list (usually an array) with
the tags association. 

The key difference between scoped-tags and the other players on the field is that scoped-tags syncs 
the array version with the association version upon each request. 

The initial array tag list implementation was half Array half beast. The current version has been updated to use a proxy
based implementation for the array list, similar to the ActiveRecord ProxyAssociation which is used for the different
relationship associations. This is the heart of the code which syncs the array style listing with the association listing.

Scoped-tags will, in its next release, allow for tags to be strictly or silently scoped, with the default allowing
tag creation if the tag does not exist.


Key Features
------------

- multiple tag contexts per model
- works with sphinx and thinking-sphinx
- add and remove tags using array like features
- association and array list stay in sync
- tags are available for use in the validations as they are always kept in sync



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

    me.interest_list => ['scuba']

    me.interest_list << 'cycling'
    # comma seperated strings are excepted, as well as arrays of strings

    me.interests => [#<Tag id: nil, name: "scuba", context: 'interests'>,#<Tag id: nil, name: "cycling", context: 'interests'>]
    


Things to watch out for
-----------------------

### _updating a scoped tagged model via a controller update_

be aware that if no tags are selected then the browser
does not pass through a blank array. This means if the model previously had tags saved to it and you remove the tags, the browser
will not pass though the changes because the select box is empty meaning the tags will not be removed. 

An example of
this is the  FCBKcomplete javascript plugin, it uses a select box behind the scenes to store the tags and pass
them through to the controller, but if none are selected then the browser passes nothing to the controller, 
not even a blank array. To fix this, add the following method to the controller and add it as a before\_filter to the update
action.  

Add to the controller:
    
    before_filter :check_blank_tag_ids, :only => :update
    
    def check_blank_tag_ids
        params[:person][:interest_ids] = [] if params[:person] && params[:person][:interest_ids].blank?
    end


### _use a transaction when updating the scoped model_

otherwise the tags will save even if the model validations fail.
This is due to the standard behavior of has\_many :through relationships.
    
Example

    Person.transaction { @person.update_attributes!(params[:person]) }




Future enhancements
-------------------

- add strict and silent scoping on setup (scoped_tags :interests, :strict => true), thus any tag added which is not already in the tags table for that context will be rejected
- get the instance.context.build method to work correctly
