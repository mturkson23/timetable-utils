#!/usr/bin/python

from utils import make_query, execute_query
from xml.etree import ElementTree
from enums import addparams, XML_DATA
import re


def add_pattern(node, free_for_all, not_available):
    pat = node.find('.//sharing/pattern')
    if pat is not None:
        pattern_unit = pat.attrib.get('unit')
        pattern_text = pat.text.strip()
        # prepare pattern list for ingestion
        pattern = list()
        pattern.append(pattern_unit)
        pattern.append('\'' + pattern_text + '\'')
        pattern.append('\''+free_for_all+'\'')
        pattern.append('\''+not_available+'\'')

        addparams['tname'] = 'xml_sharingpattern'
        addparams['xparams'] = pattern
        pat_query = make_query(addparams)
        pat_res = execute_query(pat_query)
        # get pattern id from returned transaction
        find = re.compile(r"\d+")
        pattern_id = re.search(find, pat_res[0][0]).group(0)
        return pattern_id


def add_sharingmatrix(node, room_id, pattern_id):
    for dept in node.findall('.//sharing/department'):
        dept_id = dept.attrib.get('id')
        dept_value = dept.attrib.get('value')
        # prepare sharing matrix for ingestion
        sm = [room_id, pattern_id, dept_id, dept_value]

        addparams['tname'] = 'xml_sharingmatrix'
        addparams['xparams'] = sm
        sm_query = make_query(addparams)
        execute_query(sm_query)


def insert_rooms():
    with open(XML_DATA, 'rt') as f:
        tree = ElementTree.parse(f)
    for node in tree.findall('.//rooms/room'):
        room_id = node.attrib.get('id')
        capacity = node.attrib.get('capacity')
        loc = node.attrib.get('location')
        ignore = '1' if node.attrib.get('ignoreTooFar') == 'true' else '0'
        discouraged = '1' if node.attrib.get('discouraged') == 'true' else '0'
        constraint = '1' if node.attrib.get('constraint') == 'true' else '0'
        # loc is a string
        room = [room_id, capacity, '\'' + loc + '\'',
                ignore, discouraged, constraint]
        addparams['tname'] = 'xml_room'
        addparams['xparams'] = room
        res = make_query(addparams)
        # call execute to run the prepared query on pg
        execute_query(res)

        # search for free for all tag
        ffa = node.find('.//sharing/freeForAll')
        free_for_all = ffa.attrib.get('value') if ffa is not None else 'NULL'

        # search for room not available tag
        rna = node.find('.//sharing/notAvailable')
        not_available = rna.attrib.get('value') if rna is not None else 'NULL'

        pattern_id = add_pattern(node, free_for_all, not_available)
        add_sharingmatrix(node, room_id, pattern_id)
