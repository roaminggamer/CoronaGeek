I added this code to help a new user understand and see different approaches to re-building scene content on each visit.

 * 1_bad - Doesn't rebuild.
 * 2_OKA - Same as '1_bad', but destroy scene after exiting via 'composer.removeScene( )'.
 * 3_OKB - Creates content in show-will phase, destroys in hide-did phase.  Code is embedded in methods.  Not portable
 * 4_Better - Similar to '3_OKB', but builder function is separated to make it portable and is called by willEnter() (shortcut) method.


