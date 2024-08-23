;; extends
(block_mapping_pair
  key:(flow_node) @mykey
  value: (flow_node (plain_scalar (string_scalar) @injection.content (#set! injection.language "javascript")))
  )
(block_mapping_pair
  key:(flow_node) @mykey
  value: (block_node (block_scalar) @injection.content (#set! injection.language "javascript")
                     (#offset! @injection.content 0 1 0 0)
                     )
  )
