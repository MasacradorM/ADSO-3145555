package sena.cafetin.controller;

import sena.cafetin.entity.Pedido;
import sena.cafetin.service.PedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/pedidos")
public class PedidoController {
    private final PedidoService service;
    public PedidoController(PedidoService service) { this.service = service; }

    @GetMapping
    public List<Pedido> getAll() { return service.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Pedido> getById(@PathVariable Long id) {
        return service.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Pedido create(@RequestBody Pedido pedido) { return service.save(pedido); }

    @PutMapping("/{id}")
    public ResponseEntity<Pedido> update(@PathVariable Long id, @RequestBody Pedido pedido) {
        return service.findById(id).map(existing -> {
            pedido.setId(id);
            return ResponseEntity.ok(service.save(pedido));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}