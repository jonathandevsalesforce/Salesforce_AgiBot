public class MelhorEnvioApiResponse {
    public Integer current_page;
    public List<Data> data;
    public String first_page_url;
    public Integer last_page;
    public String last_page_url;
    public List<Link> links;
    public String next_page_url;
    public String path;
    public Integer per_page;
    public String prev_page_url;
    public Integer to;
    public Integer total;
    
    public class Data {
        public String id;
        public String protocol;
        public Integer service_id;
        public String contract;
        public String service_code;
        public Decimal quote;
        public Decimal price;
        public Object coupon; // null pode usar Object ou String
        public Decimal discount;
        public Integer delivery_min;
        public Integer delivery_max;
        public String status;
        public Object reminder;
        public Decimal insurance_value;
        public Decimal weight;
        public Decimal width;
        public Decimal height;
        public Decimal length;
        public Decimal diameter;
        public String format;
        public Decimal billed_weight;
        public Boolean receipt;
        public Boolean own_hand;
        public String collect_scheduled_at;
        public Integer reverse;
        public Boolean non_commercial;
        public Object authorization_code;
        public String tracking;
        public String self_tracking;
        public Object delivery_receipt;
        public List<Object> additional_info;
        public Object cte_key;
        public String paid_at;
        public String generated_at;
        public String posted_at;
        public String delivered_at;
        public Object canceled_at;
        public Object suspended_at;
        public Object expired_at;
        public String created_at;
        public String updated_at;
        public Object received_at;
        public Boolean risk;
        public Details details;
        public Object receipt_code;
        public Boolean is_show_eticket_action;
        public Boolean is_show_correios_reverse_ppn_action;
        public To to;
        public Service service;
        public Object invoice;
        public List<Object> tags;
        public List<Product> products;
        public Conciliation conciliation;
        public List<Volume> volumes;
        public List<Object> freight_arrangements;
        public Object pudos_return_code;
    }
    
    public class Details {
        public Decimal balance;
        public String gateway;
        public String discount;
        public String subtotal;
        public String total;
    }
    
    public class FromPeople {
        public String name;
        public String phone;
        public String email;
        public String document;
        public String company_document;
        public String state_register;
        public String postal_code;
        public String address;
        public String location_number;
        public String complement;
        public String district;
        public String city;
        public String state_abbr;
        public String country_id;
        public Decimal latitude;
        public Decimal longitude;
        public String note;
        public String economic_activity_code;
    }
    
    public class To {
        public String name;
        public String phone;
        public String email;
        public String document;
        public String company_document;
        public String state_register;
        public String postal_code;
        public String address;
        public String location_number;
        public String complement;
        public String district;
        public String city;
        public String state_abbr;
        public String country_id;
        public Decimal latitude;
        public Decimal longitude;
        public String note;
        public String economic_activity_code;
    }
    
    public class Service {
        public Integer id;
        public String name;
        public String type;
        public String range;
        public Company company;
    }
    
    public class Company {
        public Integer id;
        public String name;
        public String picture;
        public String tracking_link;
    }
    
    public class Product {
        public String name;
        public Integer quantity;
        public Decimal unitary_value;
        public Decimal weight;
    }
    
    public class Conciliation {
        public Decimal billed_weight;
        public Decimal insurance_value;
        public Decimal price;
        public Decimal quote;
        public Decimal discount;
        public String status;
        public Decimal value;
        public String type;
        public Boolean distinct_metrics;
        public Object agency;
        public List<Volume> volumes;
    }
    
    public class Volume {
        public Integer id;
        public String height;
        public String width;
        public String length;
        public String diameter;
        public String weight;
        public String format;
        public String created_at;
        public String updated_at;
    }
    
    public class Link {
        public String url;
        public String label;
        public Boolean active;
    }
}