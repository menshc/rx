Deface::Override.new(:virtual_path => 'spree/layouts/spree_application',
                     :name         => 'footer_modification',
                     :replace      => 'erb[loud]:contains("spree/shared/footer")',
                     :partial => 'partials/footer'

                    )