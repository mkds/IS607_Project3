-- Table structure for table `category`

CREATE TABLE IF NOT EXISTS `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=64 ;

-- Insert Category Records into category table 

INSERT INTO category (name)
SELECT DISTINCT a.category
FROM awards a


-- update awards table with category id
-- ideally we need to rename/ create a new column called categoryId

UPDATE awards a, category c
SET a.category = c.id
where a.category = c.name