<?php
 
 /**
  * @file
  * Contains \Drupal\sesid_block\Plugin\Block\SesIdBlock
  */
 
 namespace Drupal\sesid_block\Plugin\Block;
 
 use Drupal\Core\Block\BlockBase;
 use Drupal\Component\Utility\Crypt; 
 
 /**
  *
  * @Block(
  *   id = "sessionid_block",
  *   admin_label = @Translation("Session ID Block"),
  * )
  */
 class SesIdBlock extends BlockBase {
 
   /**
    * On block call and build
    *
    * @return string
    */
   public function build() {
     $session_manager = \Drupal::service('session_manager');
     $session_id = $session_manager->getId();
     $session_id = Crypt::hashBase64($session_id);
     
     $build = array();
     $build['#markup'] = $this->t('<script>window.session_id="'.$session_id.'";</script>');
     $build['#cache']['max-age'] = 0;
     return $build;
   }
 }
