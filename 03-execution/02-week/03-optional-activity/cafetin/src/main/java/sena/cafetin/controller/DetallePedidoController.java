package sena.cafetin.controller;

import sena.cafetin.entity.DetallePedido;
import sena.cafetin.service.DetallePedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/detalle-pedido")
public class DetallePedidoController {
    private final DetallePedidoService service;
    public DetallePedidoController(DetallePedidoService service) { this.service = service; }

    @GetMapping
    public List<DetallePedido> getAll() { return service.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<DetallePedido> getById(@PathVariable Long id) {
        return service.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public DetallePedido create(@RequestBody DetallePedido detalle) { return service.save(detalle); }

    @PutMapping("/{id}")
    public ResponseEntity<DetallePedido> update(@PathVariable Long id, @RequestBody DetallePedido detalle) {
        return service.findById(id).map(existing -> {
            detalle.setId(id);
            return ResponseEntity.ok(service.save(detalle));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}