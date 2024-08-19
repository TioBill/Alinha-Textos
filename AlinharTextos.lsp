(defun c:alinharTextos(/ *error* texto_de_referencia 
                       insertion_point_texto_de_referencia 
                       textos_a_ser_modificados 
                       tipo_de_alinhamento
                       texto_atual
                       insertion_point_texto_atual
                       )

  (defun *error* (msg)
    (or 
      (wcmatch (strcase msg t) "*break,*cancel*,*exit*") 
      (alert (strcat "ERROR: " msg "**"))
    )
  )
  
  (setq texto_de_referencia (vlax-ename->vla-object (car (entsel "Selecione o texto de referencia"))))
  
  (setq insertion_point_texto_de_referencia (vlax-safearray->list (vlax-variant-value (vla-get-insertionpoint texto_de_referencia))))
  
  (if (eq (vla-get-objectname texto_de_referencia) "AcDbText")
    (setq text_alignment_texto_de_referencia (vlax-safearray->list (vlax-variant-value (vla-get-textalignmentpoint texto_de_referencia))))
  )
  
  (setq textos_a_ser_modificados (ssget (cons 0 (substr (vla-get-objectname texto_de_referencia) 5))))
  
  (initget 1 "X Y")
  (setq tipo_de_alinhamento (getkword "Tipo de alinhamento: [X - Y] "))
  
  (repeat (setq quantidade_de_textos (sslength textos_a_ser_modificados))
    (setq texto_atual (vlax-ename->vla-object (ssname textos_a_ser_modificados (setq quantidade_de_textos (1- quantidade_de_textos)))))

    (setq insertion_point_texto_atual (vlax-safearray->list (vlax-variant-value (vla-get-insertionpoint texto_atual))))
    
    (if (eq (vla-get-objectname texto_atual) "AcDbMText")
      (progn
        (vla-put-attachmentpoint texto_atual (vla-get-attachmentpoint texto_de_referencia))
        
        (if (eq tipo_de_alinhamento "X")
          (vla-put-insertionpoint texto_atual (vlax-3d-point (car insertion_point_texto_de_referencia) (cadr insertion_point_texto_atual) (caddr insertion_point_texto_atual)))
          (vla-put-insertionpoint texto_atual (vlax-3d-point (car insertion_point_texto_atual) (cadr insertion_point_texto_de_referencia) (caddr insertion_point_texto_atual)))
        )
      )
      
      (progn
        (vla-put-alignment texto_atual (vla-get-alignment texto_de_referencia))
        
        (if (eq (vla-get-alignment texto_de_referencia) 0)
          (if (eq tipo_de_alinhamento "X")
            (vla-put-insertionpoint texto_atual (vlax-3d-point (car insertion_point_texto_de_referencia) (cadr insertion_point_texto_atual) (caddr insertion_point_texto_atual)))
            (vla-put-insertionpoint texto_atual (vlax-3d-point (car insertion_point_texto_atual) (cadr insertion_point_texto_de_referencia) (caddr insertion_point_texto_atual)))
          )
          
          (progn
            (if (eq tipo_de_alinhamento "X")
              (vla-put-textalignmentpoint texto_atual (vlax-3d-point (car text_alignment_texto_de_referencia) (cadr insertion_point_texto_atual) (caddr insertion_point_texto_atual)))
              (vla-put-textalignmentpoint texto_atual (vlax-3d-point (car insertion_point_texto_atual) (cadr text_alignment_texto_de_referencia) (caddr insertion_point_texto_atual)))
            )
          )
        )
      )
    )
  )
  
  
  (princ)
)

(alert "Lisp carregada com sucesso! Digite \"alinharTextos\" para comecar!")