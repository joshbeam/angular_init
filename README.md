This README will change if the changes in this branch are merged to the master.

# Purpose of this branch

- Use the new syntax `ngi make controller` or `ngi make directive`, etc. (`ngi <verb> <object>`)
- Use the new syntax `ngi -options`

`ngi -options` will open up an interactive menu, as such:

```bash
Current settings: 
---> Language: coffee
---> Types: [{"name"=>"directive", "template"=>"basic.js"}, {"name"=>"controller", "template"=>"basic.js"}, {"name"=>"factory", "template"=>"basic.js"}, {"name"=>"service", "template"=>"basic.js"}, {"name"=>"config", "template"=>"config.js"}, {"name"=>"run", "template"=>"config.js"}, {"name"=>"routes", "template"=>"config.js"}, {"name"=>"filter", "template"=>"basic.js"}, {"name"=>"module", "template"=>"module.js"}, {"name"=>"constant", "template"=>"constant.js"}]

Type the property you want to configure: language, types
(or type ctrl+c to exit)
# => language

Choose from: es5, es6, coffee
# => es5
Language set to: es5
```

See `src/config/angular_init.config.json` to see the global configuration file that `ngi -options` interacts with.

&copy; 2015 Josh Beam (MIT License)