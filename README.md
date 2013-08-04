LESS Column Queries
===================

LESS column queries is a more readable way to express attribute values in LESS
across multiple media queries.

Example
-

#### LESS

```
@phone-query:   ~"only screen and (max-width: 767px)";
@tablet-query:  ~"only screen and (min-width: 768px) and (max-width: 979px)";
@desktop-query: ~"only screen and (min-width: 980px)";

.action-container {
  background-color: #ccc;
  font-family: 'Source Sans Pro', sans-serif;
}

@media @phone-query {
  .action-container {
    font-size: 24px;
    margin: 50px;
    padding: 10px;
    width: auto;
  }
}

@media @tablet-query {
  .action-container {
    font-size: 24px;
    margin: 50px auto;
    padding: 20px;
    width: 640px;
  }
}

@media @desktop-query {
  .action-container {
    font-size: 36px;
    margin: 50px auto;
    padding: 40px;
    width: 800px;
  }
}
```


#### LESS Column Queries

```
.action-container {
  background-color: #ccc;
  font-family: 'Source Sans Pro', sans-serif;

  font-size:    | 24px |           | 36px  |
  margin:       | 50px | 50px auto |       |
  padding:      | 10px | 20px      | 40px  |
  width:        | auto | 640px     | 800px |
}
```
