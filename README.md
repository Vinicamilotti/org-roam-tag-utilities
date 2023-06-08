
# Table of Contents

1.  [Org-Roam Tag Utilitties](#org9b13f2b)
    1.  [Description:](#org7994640)
    2.  [Requirements:](#orge0da3f6)
    3.  [Usage:](#org511683a)
        1.  [Using tags:](#org857aec9)
        2.  [Insert links for all files with a specifc tag or with matching tags:](#org4b8dcbb)
        3.  [Open a dashboard or index node without search for then](#org7c3578b)



<a id="org9b13f2b"></a>

# Org-Roam Tag Utilitties


<a id="org7994640"></a>

## Description:

-   Adds some tag related funcionalities to the Org-roam package.


<a id="orge0da3f6"></a>

## Requirements:

-   Org-roam


<a id="org511683a"></a>

## Usage:


<a id="org857aec9"></a>

### Using tags:

-   To set file tags use the #+filetags header
-   Exemple:
    
        #+filetags: :Sometag:


<a id="org4b8dcbb"></a>

### Insert links for all files with a specifc tag or with matching tags:

-   M-x org-roam-insert-by-tag RET
    -   This will open the minibuffer with a list of avaliable tags. Choose at least one. Then a list of org-roam links with the matching tags will be inserted in your buffer.


<a id="org7c3578b"></a>

### Open a dashboard or index node without search for then

-   Mark your dashboard or index node with the :Dashboard: tag then:
    -   M-x org-roam-open-dashboard RET
-   Everytime you run this function you will be redirected to the tagged file.
-   IMPORTANT: If you have more than one file tagged with :Dashboard: the file oppened by the function will be one of them, but not necesserely the one you'r looking for, so is important to tag only one file with :Dashboard: or to customize the (dashboard-tag) variable:
    
        (setq dashboard-tag "Someothertag")

Be sure to do that after you load the package

