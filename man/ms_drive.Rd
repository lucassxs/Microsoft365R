% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ms_drive.R
\docType{class}
\name{ms_drive}
\alias{ms_drive}
\title{Personal OneDrive or SharePoint document library}
\format{
An R6 object of class \code{ms_drive}, inheriting from \code{ms_object}.
}
\description{
Class representing a personal OneDrive or SharePoint document library.
}
\section{Fields}{

\itemize{
\item \code{token}: The token used to authenticate with the Graph host.
\item \code{tenant}: The Azure Active Directory tenant for this drive.
\item \code{type}: always "drive" for a drive object.
\item \code{properties}: The drive properties.
}
}

\section{Methods}{

\itemize{
\item \code{new(...)}: Initialize a new drive object. Do not call this directly; see 'Initialization' below.
\item \code{delete(confirm=TRUE)}: Delete a drive. By default, ask for confirmation first.
\item \code{update(...)}: Update the drive metadata in Microsoft Graph.
\item \code{do_operation(...)}: Carry out an arbitrary operation on the drive.
\item \code{sync_fields()}: Synchronise the R object with the drive metadata in Microsoft Graph.
\item \verb{list_items(...), list_files(...)}: List the files and folders under the specified path. See 'File and folder operations' below.
\item \code{download_file(src, dest, overwrite)}: Download a file.
\item \code{upload_file(src, dest, blocksize)}: Upload a file.
\item \code{create_folder(path)}: Create a folder.
\item \code{open_item(path)}: Open a file or folder.
\item \code{create_share_link(...)}: Create a shareable link for a file or folder.
\item \code{delete_item(path, confirm)}: Delete a file or folder.
\item \code{get_item(path)}: Get an item representing a file or folder.
\item \code{get_item_properties(path)}: Get the properties (metadata) for a file or folder.
\item \code{set_item_properties(path, ...)}: Set the properties for a file or folder.
}
}

\section{Initialization}{

Creating new objects of this class should be done via the \code{get_drive} methods of the \link{ms_graph}, \link{az_user} or \link{ms_site} classes. Calling the \code{new()} method for this class only constructs the R object; it does not call the Microsoft Graph API to retrieve or create the actual drive.
}

\section{File and folder operations}{

This class exposes methods for carrying out common operations on files and folders.

\code{list_items(path, info, full_names, pagesize)} lists the items under the specified path. It is the analogue of base R's \code{dir}/\code{list.files}. Its arguments are
\itemize{
\item \code{path}: The path.
\item \code{info}: The information to return: either "partial", "name" or "all". If "partial", a data frame is returned containing the name, size and whether the item is a file or folder. If "name", a vector of file/folder names is returned. If "all", a data frame is returned containing \emph{all} the properties for each item (this can be large).
\item \code{full_names}: Whether to prefix the full path to the names of the items.
\item \code{pagesize}: The number of results to return for each call to the REST endpoint. You can try reducing this argument below the default of 1000 if you are experiencing timeouts.
}

\code{list_files} is a synonym for \code{list_items}.

\code{download_file} and \code{upload_file} download and upload files from the local machine to the drive. For \code{upload_file}, the uploading is done in blocks of 32MB by default; you can change this by setting the \code{blocksize} argument. For technical reasons, the block size \href{https://docs.microsoft.com/en-us/graph/api/driveitem-createuploadsession?view=graph-rest-1.0#upload-bytes-to-the-upload-session}{must be a multiple of 320KB}.

\code{create_folder} creates a folder with the specified path. Trying to create an already existing folder is an error.

\code{open_item} opens the given file or folder in your browser.

\code{create_share_link(path, type, expiry, password, scope)} returns a shareable link to the item. Its arguments are
\itemize{
\item \code{path}: The path.
\item \code{type}: Either "view" for a read-only link, "edit" for a read-write link, or "embed" for a link that can be embedded in a web page. The last one is only available for personal OneDrive.
\item \code{expiry}: How long the link is valid for. The default is 7 days; you can set an alternative like "15 minutes", "24 hours", "2 weeks", "3 months", etc. To leave out the expiry date, set this to NULL.
\item \code{password}: An optional password to protect the link.
\item \code{scope}: Optionally the scope of the link, either "anonymous" or "organization". The latter allows only users in your AAD tenant to access the link, and is only available for OneDrive for Business or SharePoint.
}

This function returns a URL to access the item, for \code{type="view"} or "\verb{type=edit"}. For \code{type="embed"}, it returns a list with components \code{webUrl} containing the URL, and \code{webHtml} containing a HTML fragment to embed the link in an IFRAME. The default is a viewable link, expiring in 7 days.

\code{delete_item} deletes a file or folder. By default, it will ask for confirmation first.

\code{get_item} returns an object of class \link{ms_drive_item}, containing the properties (metadata) for a given file or folder and methods for working with it.

\code{get_item_properties} is a convenience function that returns the properties of a file or folder as a list.

\code{set_item_properties} sets the properties of a file or folder. The new properties should be specified as individual named arguments to the method. Any existing properties that aren't listed as arguments will retain their previous values or be recalculated based on changes to other properties, as appropriate.
}

\examples{
\dontrun{

# personal OneDrive
mydrv <- personal_onedrive()

# OneDrive for Business
busdrv <- business_onedrive("mycompany")

# shared document library for a SharePoint site
site <- sharepoint_site("https://mycompany.sharepoint.com/sites/my-site-name")
drv <- site$get_drive()

## file/folder operationss
drv$list_items()
drv$list_items("path/to/folder", full_names=TRUE)

# download a file -- default destination filename is taken from the source
drv$download_file("path/to/folder/data.csv")

# shareable links
drv$create_share_link("myfile")
drv$create_share_link("myfile", type="edit", expiry="24 hours")
drv$create_share_link("myfile", password="Use-strong-passwords!")

# file metadata (name, date created, etc)
drv$get_item_properties("myfile")

# rename a file
drv$set_item_properties("myfile", name="newname")

}
}
\seealso{
\link{personal_onedrive}, \link{business_onedrive}, \link{ms_site}, \link{ms_drive_item}

\href{https://docs.microsoft.com/en-us/graph/overview}{Microsoft Graph overview},
\href{https://docs.microsoft.com/en-us/graph/api/resources/onedrive?view=graph-rest-1.0}{OneDrive API reference}
}
