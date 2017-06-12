#!/usr/bin/python
import time
from parse_room import insert_rooms
from parse_class import insert_classes
from parse_constraints import insert_groupconstraints
from parse_students import insert_students
from xml_composer import write_xml


start_time = time.time()


def read_xml():
    print "parsing room from xml. inserting to db..."
    insert_rooms()
    print "parsing classes from xml. inserting to db..."
    insert_classes()
    print "parsing group constraints from xml. inserting to db..."
    insert_groupconstraints()
    print "parsing students from xml. inserting to db..."
    insert_students()


if __name__ == '__main__':
    # read_xml()
    write_xml()
    # print("--- Executed in %s seconds ---" % (time.time() - start_time))
    #TODO: lxml
