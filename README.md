# Contacts

The application shows all contacts from the iPhone Contact list.
You can see more details about contact by tapping in contact.
Every change in the iPhone Contact list will be applied in the application.

In this application, I used the MVVM architectural pattern.
For ContactModel I apply a Builder structural design pattern.
Used UniteTest for ViewModels and Utility classes.
For TableView datasource methods created another class(TableViewDataSource) and datasource all functionality moved to that class.
UITbaleViewCells are being built with identifiers that have every cell model (all cell models conform to protocol BaseModel)
Used Storyboards because the application is very simple, otherwise UIViewControllers could be created with XIB files.
