
Deface::Override.new(:virtual_path => 'spree/layouts/spree_application',
                     :name         => 'header_modification',
                     :replace      => 'erb[loud]:contains("spree/shared/header")',
                     :partial      =>  "partials/header"

                    )