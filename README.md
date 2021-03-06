LESS Query Columns
==================

LESS query columns is a more readable way to express attribute values in LESS
across multiple media queries.

#### Disclaimer

Note: This was made during a hackathon, I'll have usage docs up soon.  I'll
also add tests and better error messages.

I'm also considering forking less.js once I can take the time to read through
the code.

Example
-

#### LESS Query Columns

```css
.action-container {
  background-color: #ccc;
  font-family: 'Source Sans Pro', sans-serif;

  font-size: | 24px |       | 36px  |
    padding: | 10px | 20px  |       |
      width: | auto | 640px | 800px |
}
```

#### Resulting LESS

```css
@phone-width-query:   ~"only screen and (max-width: 767px)";
@tablet-width-query:  ~"only screen and (min-width: 768px) and (max-width: 979px)";
@desktop-width-query: ~"only screen and (min-width: 980px)";

.action-container {
  background-color: #ccc;
  font-family: 'Source Sans Pro', sans-serif;
}

@media @phone-width-query {
  .action-container {
    font-size: 24px;
    padding: 10px;
    width: auto;
  }
}

@media @tablet-width-query {
  .action-container {
    font-size: 24px;
    padding: 20px;
    width: 640px;
  }
}

@media @desktop-width-query {
  .action-container {
    font-size: 36px;
    margin: 50px auto;
    padding: 20px;
    width: 800px;
  }
}
```

Features
-

#### Multiple Query Columns

Define columns and queries in `config.json`:

```js
{
  "columns": {
    "width": {
      "phone":        "only screen and (max-width: 767px)",
      "tablet":       "only screen and (min-width: 768px) and (max-width: 979px)",
      "desktop":      "only screen and (min-width: 980px) and (max-width: 1199px)",
      "large-screen": "only screen and (min-width: 1200px)"
    },
    "height": {
      "small":  "only screen and (max-height: 400px)",
      "medium": "only screen and (min-height: 401px) and (max-height: 600px)",
      "large":  "only screen and (min-height: 601px)"
    }
  },
  "defaultColumns": "width"
}
```

Refer to columns as such:

```css
.container {
               | @width-columns                |
      padding: | 10px |       | 20px  |        |
        width: | 100% | 720px | 900px | 1080px |

               | @height-columns      |
    font-size: | 24px | 20px  | 16px  |
  line-height: | 1    | 1.2   |       |
}
```
