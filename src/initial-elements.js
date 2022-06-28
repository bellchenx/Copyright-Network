import React from 'react';
import { MarkerType } from 'react-flow-renderer';

export const nodes = [
  {
    id: '2',
    data: {
      label: (
        <>
          <strong>Copyright 2</strong>
        </>
      ),
    },
    position: { x: 200, y: 0 },
  },
  {
    id: '1',
    data: {
      label: (
        <>
          <strong>Copyright 1</strong>
        </>
      ),
    },
    position: { x: 100, y: 100 },
  },
  {
    id: '3',
    data: {
      label: (
        <>
          <strong>NFT Distribution</strong>
        </>
      ),
    },
    position: { x: 100, y: 200 },
    style: {
      background: '#D6D5E6',
      color: '#333',
      border: '1px solid #222138',
    },
  },
  {
    id: '4',
    position: { x: 0, y: 0 },
    data: {
      label: (
        <>
          <strong>Copyright 3</strong>
        </>
      ),
    },
  },
  {
    id: '5',
    data: {
      label: (
        <>
          <strong>NFT Distribution</strong>
        </>
      ),
    },
    position: { x: 0, y: -100 },
    style: {
      background: '#D6D5E6',
      color: '#333',
      border: '1px solid #222138',
    },
  },
  {
    id: '6',
    data: {
      label: (
        <>
          <strong>NFT Distribution</strong>
        </>
      ),
    },
    position: { x: 200, y: -100 },
    style: {
      background: '#D6D5E6',
      color: '#333',
      border: '1px solid #222138',
    },
  }
];

export const edges = [
  { id: 'e1-3', source: '1', target: '3' },
  {
    id: 'e1-2',
    source: '2',
    target: '1',
    animated: true,
    label: 'royalty',
  },
  {
    id: 'e1-4',
    source: '4',
    target: '1',
    animated: true,
    label: 'royalty',
  },
  { id: 'e5-4', source: '5', target: '4' },
  { id: 'e2-6', source: '6', target: '2' }
];
