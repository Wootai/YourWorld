/// Free a block at x,y,z (or decrease its reference count at least)
/// x = argument0
/// y = argument1
/// z = argument2
var _x=argument0;
var _y=argument1;
var _z=argument2;

var column = ds_grid_get(Map,_x,_y);

// First, check to see if we need to expand the array to include the requested _Z
var len = array_length_1d( column );
if( (len-1)<_z ){
    // if we have to expand the array, then the requested block will point to 
    // "cube" 0, which will have more than one ref, so it'll fall through into the 
    // make unique part, and so the array will THEN be written into the grid.
    for(var i=len;i<=_z;i++){
        column[i]=0;           // fill with block "0"
        RefCount[0]++;
    }
}

// Store the new free block_info index on the free list stack, and free the ref count
var blk = column[_z];
DecRef(blk);

// Now set the block to our "empty" block
column[_z] = 0;
IncRef(0);

if( GetRef(blk)==0 ){
    ds_stack_push(FreeList, blk);
}

// Now write the new modified column back into the map
ds_grid_set(Map,_x,_y,column);


